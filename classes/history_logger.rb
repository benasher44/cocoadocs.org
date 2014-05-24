class HistoryLogger
  include HashInit
  attr_accessor :spec

  def append_state state
    
    log_folder = $active_folder  + "/logs"
    log_file = log_folder + "/log.csv"

    Dir.mkdir(log_folder) unless File.exist?(log_folder)
    `touch #{log_file}` unless File.exists? log_file
    
    appledoc = `appledoc --version`.strip.gsub("appledoc version: ", "")
    git_sha = `git rev-parse HEAD`.strip
    
    open(log_file, 'a') do |f|
      f.puts [ Time.new, @spec.name, @spec.version, state, git_sha, appledoc ].join(",")
    end
    
  end
end
