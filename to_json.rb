# encoding: utf-8
# to_json.rb
# author: dice2000
# original author: aoitaku
# https://gist.github.com/aoitaku/7822424
# 
# to_yaml.rbをjsonに対応させたもの
# デバッグ途中
#
require 'jsonable'
require 'zlib'
require_relative 'rgss2'
[
  'Data/Actors.rvdata',
  'Data/Animations.rvdata',
  'Data/Areas.rvdata',
  'Data/Armors.rvdata',
  'Data/Classes.rvdata',
  'Data/CommonEvents.rvdata',
  'Data/Enemies.rvdata',
  'Data/Items.rvdata',
  *Dir.glob('Data/Map[0-9][0-9][0-9].rvdata'),
#  'Data/MapInfos.rvdata',
  'Data/Skills.rvdata',
  'Data/States.rvdata',
  'Data/System.rvdata',
  'Data/Troops.rvdata',
  'Data/Weapons.rvdata'
].each do |rvdata|
  data = ''
  File.open(rvdata, 'rb') do |file|
    data = Marshal.load(file.read)
    if data.is_a?(Array)
	    data.each{ |d|
	    	d.force_encording if d != nil
	    }
	elsif data.is_a?(Hash)
		data.force_encording if data.size != 0
	else
		data.force_encording
    end
  end
  File.open('Data/'+File.basename(rvdata,'.rvdata')+'.json', 'w') do |file|
    file.write(data.to_json)
  end
end

