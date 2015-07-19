# coding: utf-8
# to_rvdata.rb
# author: dice2000
# original author: aoitaku
# https://gist.github.com/aoitaku/7822424
#
# Area.rvdata, Scripts.rvdata未対応
require 'jsonable'
require 'zlib'
require_relative 'rgss2'

def restore_rvdata(list)
	return unless list.has_key?("json_class")
	obj = nil
	case list["json_class"]
		when "Color"
			obj = Color.new([0,0,0,0])
		when "Table"
			obj = Table.new([1,1,0,0,1,[]])
		when "Tone"
			obj = Tone.new([0,0,0,0])
		when "RPG::Event"
			obj = RPG::Event.new(list["@x"], list["@y"])
		when "RPG::EventCommand"
			obj = RPG::EventCommand.new(list["@code"], list["@indent"], list["@parameters"])
		when "RPG::MoveCommand"
			obj = RPG::MoveCommand.new(list["@code"], list["@parameters"])
#		when "RPG::BaseItem::Feature"
#			obj = RPG::BaseItem::Feature.new(list["@code"], list["@data_id"], list["@value"])
#		when "RPG::UsableItem::Effect"
#			obj = RPG::UsableItem::Effect.new(list["@code"], list["@data_id"], list["@value1"], list["@value2"])
		when "RPG::Map"
			obj = RPG::Map.new(list["@width"], list["@height"])
		when "RPG::BGM"
			obj = RPG::BGM.new(list["@name"], list["@volume"], list["@pitch"])
		when "RPG::BGS"
			obj = RPG::BGS.new(list["@name"], list["@volume"], list["@pitch"])
		when "RPG::ME"
			obj = RPG::ME.new(list["@name"], list["@volume"], list["@pitch"])
		when "RPG::SE"
			obj = RPG::SE.new(list["@name"], list["@volume"], list["@pitch"])
		else
			str = "obj=" + list["json_class"] + ".new"
			eval(str)
	end
	iterate_setting_value(obj, list)
	return obj
end

def iterate_setting_value(target, list)
	val = target.instance_variables
	val.each{|d|
		#マップイベントデータの場合
		if d == :@events
			list[d.to_s].each{|k, v|
				target.events[k.to_i] = restore_rvdata(v)
			}
		# 値がクラスオブジェクト
		elsif list[d.to_s].is_a?(Hash)
			target.instance_variable_set(d, restore_rvdata(list[d.to_s]))
		# 値がクラスオブジェクトの配列
		elsif list[d.to_s].is_a?(Array) && list[d.to_s][0].is_a?(Hash)
			data_trans = []
			list[d.to_s].each{|d|
				data_trans << restore_rvdata(d)
    	}
    	target.instance_variable_set(d, data_trans)
		else
			target.instance_variable_set(d, list[d.to_s])
		end
	}
end


[
  'Data/Actors.json',
  'Data/Animations.json',
#  'Data/Areas.json',
  'Data/Armors.json',
  'Data/Classes.json',
  'Data/CommonEvents.json',
  'Data/Enemies.json',
  'Data/Items.json',
  *Dir.glob('Data/Map[0-9][0-9][0-9].json'),
  'Data/MapInfos.json',
  'Data/Skills.json',
  'Data/States.json',
  'Data/System.json',
  'Data/Troops.json',
  'Data/Weapons.json'
].each do |json|
  text = ''
  p json
  f = File.open(json, 'r:utf-8')
  f.each {|line|
  	text += line
  }
  data = JSON.parse(text)
  data_trans = nil
  if data.is_a?(Array)
  	data_trans = []
    data.each{ |d|
    	if d == nil
    		data_trans << d
    	else
    		data_trans << restore_rvdata(d)
    	end
    }
  #あまり賢くない方法で対処（後で考える）
  elsif data.is_a?(Hash)
	  if json == 'Data/MapInfos.json'
	  	data_trans = {}
	  	data.each{|k, v|
	  		data_trans[k.to_i] = restore_rvdata(v)
	  	}
	  else
	  	data_trans = restore_rvdata(data)
	  end
	else
		data_trans = restore_rvdata(data)
  end
  #p data_trans
  File.open('Data/'+File.basename(json,'.json')+'.rvdata', 'wb') do |file|
    file.write(Marshal.dump(data_trans))
  end
  f.close
end