gem 'minitest'
require 'minitest/autorun'


class TestNaughtyWords < MiniTest::Test 

	def test_filter(message) 
		@naugthy_words = ['poo', 'fuck', 'asshole', 'ass', 'bustard']
		@replace_with = ['Nathaniel']
			message.gsub! (/\b#{cuss}\b/i)
				@replace_with[@naugthy_words.index(cuss)]
		end

		return text
	
end

