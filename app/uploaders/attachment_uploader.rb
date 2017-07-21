class AttachmentUploader < BaseUploader
  def content_type_whitelist
    [%r{^image/}, %r{^video/}, %r{^text/}]
  end
end
