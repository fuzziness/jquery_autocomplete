puts "Removing files..."
dir = "javascripts"
["jquery-ui.min.js jquery-ui-i18n.min.js"].each do |js_file|
	dest_file = File.join(Rails.root, "public", dir, js_file)
	FileUtils.rm_r(dest_file)
end
puts "Files removed - Uninstallation complete!"