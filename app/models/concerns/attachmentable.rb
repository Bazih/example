require 'active_support/concern'

module Attachmentable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, dependent: :destroy, as: :attachmentable
    accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  end
end