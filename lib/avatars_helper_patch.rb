# Redmine Local Avatars plugin
#
# Copyright (C) 2010  Andrew Chaika, Luca Pireddu
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'local_avatars'

module LocalAvatarsPlugin
  module AvatarsHelperPatch
    def self.included(base) # :nodoc:    
      base.class_eval do
        alias_method :avatar_without_local, :avatar
        alias_method :avatar, :avatar_with_local
      end
    end

		def avatar_with_local(user, options = { })
			if user.is_a?(User) then
				avatar = user.attachments.find_by_description 'avatar'
				options[:class] = GravatarHelper::DEFAULT_OPTIONS[:class] + " " + options[:class] if options[:class]
				options[:style] = "margin-left: 0px"
				if avatar then
					image_url = url_for :only_path => true, :controller => 'account', :action => 'get_avatar', :id => user
					return image_tag image_url, GravatarHelper::DEFAULT_OPTIONS.except(:default, :rating, :ssl).merge(options)
				else
					return image_tag 'anonymous.png', GravatarHelper::DEFAULT_OPTIONS.except(:default, :rating, :ssl).merge(options)
				end
			end
			avatar_without_local(user, options)
		end
  end
end