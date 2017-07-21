class Photographers::AvailableHours
  def initialize(photographer, params = {}, order = nil)
    @photographer = photographer
    @date  = params['date']
    @time  = params['time']
    @order = order
  end

  attr_reader :order, :date, :time

  def call
    free_date_ranges(unavailable_periods)
  end

  private

  def preferred_date
    return DateTime.parse(date + ' ' + time) if date.present? && time.present?
    start_at
  end

  def start_at
    return DateTime.parse(default_date + ' ' + '08:00:00') if @photographer.start_work_at.blank?
    DateTime.parse(default_date + ' ' + @photographer.start_work_at.strftime('%H:%M:%S'))
  end

  def end_at
    return (start_at + 8.hours) if @photographer.end_work_at.blank?
    DateTime.parse(start_at.strftime('%Y-%m-%d') + ' ' + @photographer.end_work_at.strftime('%H:%M:%S'))
  end

  def default_date
    @default_date ||= date.present? ? date : (Date.current + 1.day).to_s
  end

  # rubocop:disable all
  # in minutes
  def execution_time
    @execution_time ||= order.attribute_ids_with_qauntity.map do |data|
      att = photographer_attributes.find_by(attribute_item_id: data.first)
      att.default_time + data.last.modulo(att.attribute_item.base_quantity) * att.extra_time
    end.sum
  end
  # rubocop:enable all

  def unavailable_periods
    @photographer.calendar_items.where(
      "(unavailable_from BETWEEN :start_at AND :end_at) OR (unavailable_to BETWEEN :start_at AND :end_at) \
       OR (:start_at >= unavailable_from AND :end_at < unavailable_to)", start_at: start_at, end_at: end_at
    ).order(:unavailable_from).pluck(:unavailable_from, :unavailable_to)
  end

  # rubocop:disable all
  def free_date_ranges(unavailable_ranges)
    return [] if preferred_date < start_at
    return [(preferred_date..up_to_time)] if unavailable_ranges.empty? && time.present?
    return [(start_at..end_at)] if unavailable_ranges.empty? && time.blank?

    list_of_hours = unavailable_ranges.flatten.map(&:to_datetime).unshift(start_at).push(end_at)
    partition_arrays = list_of_hours.partition.with_index{ |_v, index| index.even? } # => [[v1, v3,...], [v2, v4,...]]
    list_of_ranges = partition_arrays.first.zip(partition_arrays.last)

    free_ranges = list_of_ranges.reduce([]) do |result, period|
      free_time = ((period.last.to_time - period.first.to_time).to_i) / 60
      free_time > execution_time ? result << (period.first..period.last) : result
    end

    return free_ranges unless time.present?

    free_ranges.map do |diapason|
      next unless diapason.cover?(preferred_date)
      next if diapason.last < up_to_time
      (preferred_date..up_to_time)
    end.compact
  end
  # rubocop:enable all

  def photographer_attributes
    @photographer_attributes ||= @photographer.photographer_attributes
  end

  def up_to_time
    @up_to_time ||= preferred_date + execution_time.minutes
  end
end
