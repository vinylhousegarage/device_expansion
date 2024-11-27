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
end
