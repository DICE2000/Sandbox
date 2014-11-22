# coding: utf-8
# to_rvdata.rb
# author: dice2000
# original author: aoitaku
# https://gist.github.com/aoitaku/7822424
# 
# to_rvdata2.rbをリネームして拡張子変えただけ
# デバッグはまだ
#
require 'json'
require 'zlib'
require_relative 'rgss2'
[
  'Data/Actors.json',
  'Data/Animations.json',
  'Data/Areas.json',
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
  data = ''
  f = File.open(json)
  data = JSON.load(f)
  File.open('Data/'+File.basename(json,'.json')+'.rvdata', 'wb') do |file|
    file.write(Marshal.dump(data))
  end
  f.close
end

