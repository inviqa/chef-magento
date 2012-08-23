# Chef 0.10.10 or greater
default_action :init

# In earlier versions of Chef the LWRP DSL doesn't support specifying
# a default action, so you need to drop into Ruby.
def initialize(*args)
  super
  @action = :init
end

actions :init, :updateall, :deployall, :repair, :clean,
:checkout, :clone, :link, :update, :deploy, :deploycopy

attribute :project_path, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String, :name_attribute => true