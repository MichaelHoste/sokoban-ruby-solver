class Pack

  attr_reader :file_name, :name, :description, :email, :url, :copyright,
              :max_cols, :max_rows, :levels

  def initialize(file_path)
    File.open(file_path) do |file|
      xml_pack_node = Nokogiri::XML(file)

      copyright_node = xml_pack_node.css('SokobanLevels LevelCollection').attr('Copyright')

      @file_name   = File.basename(file_path)
      @name        = xml_pack_node.css('SokobanLevels Title').text.strip
      @description = xml_pack_node.css('SokobanLevels Description').text.strip
      @email       = xml_pack_node.css('SokobanLevels Email').text.strip
      @url         = xml_pack_node.css('SokobanLevels Url').text.strip
      @copyright   = copyright_node ? copyright_node.text.strip : ""
      @max_cols    = xml_pack_node.css('SokobanLevels LevelCollection').attr('MaxWidth').text.strip.to_i
      @max_rows    = xml_pack_node.css('SokobanLevels LevelCollection').attr('MaxHeight').text.strip.to_i

      @levels = []

      xml_pack_node.css('LevelCollection Level').each do |xml_level_node|
        @levels << Level.new(xml_level_node.to_s)
      end
    end
  end

  def print
    @levels.each do |level|
      puts "Name: #{level.name}"
      puts "----"
      level.print
      puts "\n\n"
    end
  end

end
