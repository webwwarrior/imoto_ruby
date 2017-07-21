module Admin::PhotographersHelper
  def time_format(time)
    time&.strftime('%I:%M %p')
  end
end
