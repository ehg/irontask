#=require guid
describe "Guid", ->
	it "should generate a new guid", ->
		expect(IronTask.Guid.new).toNotBe null
	it "should ensure a given (valid) guid is valid", ->
		expect(IronTask.Guid.is_valid "5A849634-EF4D-11E0-ACF7-76714824019B").toBeTruthy()

