class ImagePreviewInput < SimpleForm::Inputs::FileInput
  def input
    version = input_html_options.delete(:preview_version)
    out = ''
    if object.send("#{attribute_name}?")
      out << template.image_tag(object.send(attribute_name).tap{ |o| break o.send(version) if version }.send('url'))
      out << @builder.hidden_field("#{attribute_name}_cache")
    end
    out << @builder.file_field(attribute_name, input_html_options)
    out.html_safe
  end
end
