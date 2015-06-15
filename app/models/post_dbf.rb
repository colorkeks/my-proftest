class PostDbf < ActiveRecord::Base
  acts_as_copy_target
  belongs_to :officfun_dbf, class_name: 'OfficfunDbf', foreign_key: :postcode, primary_key: 'postcode'
end