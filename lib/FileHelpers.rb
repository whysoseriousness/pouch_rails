Module FileHelpers
    def save_string_to_file(str, file_path)
        File.open(file_path, "w") { |file| file.write str }
    end
end
