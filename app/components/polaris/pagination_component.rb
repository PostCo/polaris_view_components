# frozen_string_literal: true

module Polaris
  class PaginationComponent < Polaris::Component
    def initialize(
      previous_url: nil,
      next_url: nil,
      label: nil,
      button_data: {},
      **system_arguments
    )
      @previous_url = previous_url
      @next_url = next_url
      @label = label
      @button_data = button_data

      @system_arguments = system_arguments
      @system_arguments["aria-label"] = "Pagination"

      @button_group_arguments = {}
      @button_group_arguments[:segmented] = !label.present?
    end
  end
end
