

class GetTime < Plugin
        def gettime(m)
          m.reply DateTime.now.to_s
        end
end

plugin = GetTime.new
plugin.map 'gettime'


