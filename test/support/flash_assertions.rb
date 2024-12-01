module FlashAssertions
  def assert_flash_set(expected_message, key: 'notice')
    assert flash[key], "flash[:#{key}] not set"
    assert_equal expected_message, flash[key], "flash[:#{key}] mismatch"
  end

  def assert_flash_key_present(key)
    assert flash[key], "flash[:#{key}] is nil"
  end

  def assert_flash_key_absent(key)
    assert_nil flash[key], "flash[:#{key}] is not nil (value: #{flash[key]})"
  end

  def assert_flash_rendered_by_message(expected_message, key: nil)
    selector = key ? "div##{key}" : "div[id^='flash-']"
    assert_select selector, text: expected_message do |elements|
      assert elements.present?,
             "Expected flash with message '#{expected_message}' to be rendered, but it was not found."
    end
  end

  def assert_flash_not_rendered_by_message(unexpected_message, key: nil)
    selector = key ? "div##{key}" : "div[id^='flash-']"
    assert_select selector do |elements|
      if elements.present?
        rendered_messages = elements.map { |el| el.text.strip }
        assert_not rendered_messages.include?(unexpected_message),
                   "Unexpected message '#{unexpected_message}' " \
                   "found in flash. Rendered messages: #{rendered_messages.join(', ')}"
      end
    end
  end
end
