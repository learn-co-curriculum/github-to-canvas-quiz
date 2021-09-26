module FileHelpers
  def in_temp_dir(remove_after: true)
    tmp_path = nil
    while tmp_path.nil? || File.directory?(tmp_path)
      filename = "test#{Time.now.to_i}#{rand(300).to_s.rjust(3, '0')}"
      tmp_path = File.expand_path(File.join('./tmp/', filename))
    end
    FileUtils.mkdir(tmp_path)
    FileUtils.cd tmp_path do
      yield tmp_path
    end
    FileUtils.rm_r(tmp_path) if remove_after
  end
end
