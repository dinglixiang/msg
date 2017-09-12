class CommonService
  delegate :success, :failure, to: :class

  class << self
    def success(data = {})
      {code: 0, message: 'success', data: data}
    end

    def failure(opts={})
      {code: opts.fetch(:code), message: opts.fetch(:message)}
    end

    def pagination_info_of(data)
      {
        page:        data.current_page,
        total_pages: data.total_pages,
        total_count: data.total_count
      }
    end
  end
end
