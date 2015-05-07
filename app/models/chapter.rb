class Chapter < ActiveRecord::Base
  include TheSortableTree::Scopes
  acts_as_nested_set
end