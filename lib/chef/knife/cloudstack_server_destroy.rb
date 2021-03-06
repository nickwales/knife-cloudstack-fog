# Author:: Jeff Moody (<jmoody@datapipe.com>)
# Copyright:: Copyright (c) 2012 Datapipe
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


require 'chef/knife/cloudstack_base'

class Chef
  class Knife
    class CloudstackServerDestroy < Knife

      include Knife::CloudstackBase
      banner "knife cloudstack server destroy INSTANCE_ID"

      def run

        if @name_args.nil? || @name_args.empty?
          puts "#{ui.color("Please provide an Instance ID.", :red)}"
        end

        @name_args.each do |instance_id|
          response = connection.list_virtual_machines('name' => instance_id)
          instance_name = response['listvirtualmachinesresponse']['virtualmachine'].first['name']
          instance_ip = response['listvirtualmachinesresponse']['virtualmachine'].first['nic'].first['ipaddress']
          real_instance_id = response['listvirtualmachinesresponse']['virtualmachine'].first['id']
          puts "#{ui.color("Name", :red)}: #{instance_name}"
          puts "#{ui.color("Public IP", :red)}: #{instance_ip}"
          puts "\n"
          confirm("#{ui.color("Do you really want to destroy this server", :red)}")
          connection.destroy_virtual_machine('id' => real_instance_id)
          ui.warn("Destroyed server #{instance_name}")
        end
      end




    end
  end
end
