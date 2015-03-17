# coding: utf-8
require 'jsonable'
require 'zlib'
require_relative 'rgss3'
[
  'Data/Actors.json',
  'Data/Animations.json',
  'Data/Armors.json',
  'Data/Classes.json',
  'Data/CommonEvents.json',
  'Data/Enemies.json',
  'Data/Items.json',
  *Dir.glob('Data/Map[0-9][0-9][0-9].json'),
#  'Data/MapInfos.json',
  'Data/Skills.json',
  'Data/States.json',
  'Data/System.json',
  'Data/Tilesets.json',
  'Data/Troops.json',
  'Data/Weapons.json'
].each do |json|
  data = ''
  f = File.open(json)
  data = JSON.load(f)
  File.open('Data/'+File.basename(json,'.json')+'.rvdata2', 'wb') do |file|
    file.write(Marshal.dump(data))
  end
  f.close
end
#data = YAML.load_file('Data/Scripts.yml')
#Dir.glob('Data/Scripts/*.rb') do |rb|
#  File.open(rb, 'rb') do |file|
#    file.read.gsub(/(\r\n|\r|\n)/, "\n").split("# -*- END_OF_SCRIPT -*-\n\n").map do |src|
#      head, lf, script = src.partition("\n")
#      id = /id: (\d+)/.match(head).to_a.at(1).to_i
#      name = File.basename(rb, '.rb')
#      name = '' if name == "( NONAME )"
#      data[data.index(id)] = [id, name, Zlib::Deflate.deflate(script.chop)]
#    end
#  end
#end
#File.open('Data/Scripts.rvdata2', 'wb') do |file|
#  file.write(Marshal.dump(data))
#end
