module FlashAssertions
  def assert_flash_set(key, expected_message)
    assert flash[key], "flash[:#{key}] not set"
    assert_equal expected_message, flash[key], "flash[:#{key}] mismatch"
  end

  def assert_flash_key_present(key)
    assert flash[key], "flash[:#{key}] is nil"
  end

  def assert_flash_key_absent(key)
    assert_nil flash[key], "flash[:#{key}] is not nil (value: #{flash[key]})"
  end

  def assert_flash_rendered_by_message(expected_message, key: 'flash')
    assert_select "div##{key}" do |elements|
      assert elements.present?, "Expected flash[:#{key}] with message '#{expected_message}' to be rendered in div##{key}, but it was not found."
      assert_equal expected_message, elements.first.text.strip, "flash[:#{key}] message mismatch: expected '#{expected_message}', got '#{elements.first.text.strip}'."
    end
  end

  def assert_flash_not_rendered_by_message(unexpected_message, key: 'flash')
    assert_select "div##{key}" do |elements|
      if elements.present?
        rendered_messages = elements.map { |el| el.text.strip }
        assert_not rendered_messages.include?(unexpected_message),
                   "Unexpected message '#{unexpected_message}' found in div##{key}. Rendered messages: #{rendered_messages.join(', ')}"
      end
    end
  end
end
