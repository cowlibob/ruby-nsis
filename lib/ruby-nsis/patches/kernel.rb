module Kernel
  def require_glob(path)
    absolute_path = File.join(File.dirname(caller[0]), path.to_s)
    if path.match(/[\*\?]/)
      Dir.glob(absolute_path).each do |rb|
        require rb
      end
    else
      require absolute_path
    end
  end
end