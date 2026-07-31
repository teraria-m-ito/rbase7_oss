require 'test_helper'
class RakeTest1 < ActiveSupport::TestCase

  test "the truth" do
    ::Dwh::DwhOriginalInstructorMaster.update_instructors
    assert true
  end
end
