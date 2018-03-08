# This is to avoid conflict with Kaminari, which is used by ActiveAdmin.

require 'will_paginate/active_record'
module WillPaginate
  module ActiveRecord
    module RelationMethods
      alias_method :total_count, :count
    end
  end
end