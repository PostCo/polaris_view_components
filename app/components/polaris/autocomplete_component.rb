module Polaris
  class AutocompleteComponent < Component
    renders_one :text_field, ->(**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, %w[
        click->polaris-autocomplete#toggle
        click@window->polaris-popover#hide
      ])

      system_arguments[:input_options] ||= {}
      system_arguments[:input_options][:data] ||= {}
      system_arguments[:input_options][:data][:polaris_autocomplete_target] = "input"
      error_message = error_for(@attribute)
      error = error_message.presence || false

      TextFieldComponent.new(form: @form, attribute: @attribute, name: @name, error: error, **system_arguments)
    end
    renders_many :sections, ->(**system_arguments) do
      Autocomplete::SectionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_many :options, ->(**system_arguments) do
      Autocomplete::OptionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_one :empty_state
    renders_one :fetching_state

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      multiple: false,
      url: nil,
      add_input_event_listener: true,
      selected: [],
      selected_label: [],
      popover_arguments: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @multiple = multiple
      @url = url
      @add_input_event_listener = add_input_event_listener
      @selected = selected
      @selected_label = selected_label
      @popover_arguments = popover_arguments
      @system_arguments = system_arguments
    end

    def error_for(attribute)
      return if @form&.object.blank?
      return unless @form.object.errors.key?(attribute)

      raw @form.object.errors.full_messages_for(attribute)&.first
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        opts[:data][:controller] = "polaris-autocomplete"
        if @url.present?
          opts[:data][:polaris_autocomplete_url_value] = @url
        end
        opts[:data][:polaris_autocomplete_selected_value] = @selected
        opts[:data][:polaris_autocomplete_selected_label_value] = @selected_label
        opts[:data][:polaris_autocomplete_add_input_event_listener_value] = @add_input_event_listener
        opts[:data][:polaris_autocomplete_multiple_value] = @multiple if @multiple.present?
      end
    end

    def popover_arguments
      {
        alignment: :left,
        full_width: true,
        inline: false,
        text_field_activator: true,
        wrapper_arguments: {}
      }.deep_merge(@popover_arguments).tap do |opts|
        opts[:wrapper_arguments][:data] ||= {}
        prepend_option(opts[:wrapper_arguments][:data], :polaris_autocomplete_target, "popover")
      end
    end

    def option_list_arguments
      {
        data: {polaris_autocomplete_target: "results"}
      }
    end
  end
end
