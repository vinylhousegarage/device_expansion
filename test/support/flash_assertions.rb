module FlashAssertions
  def assert_flash(key, expected_message)
    assert flash[key], "Expected flash[:#{key}] to be set"
    assert_equal expected_message, flash[key], "Expected flash[:#{key}] to be '#{expected_message}', but was '#{flash[key]}'"
  end

  def assert_flash_present(key)
    assert flash[key], "Expected flash[:#{key}] to be present, but it was nil"
  end

  def assert_flash_absent(key)
    assert_nil flash[key], "Expected flash[:#{key}] to be nil, but it was '#{flash[key]}'"
  end
end
