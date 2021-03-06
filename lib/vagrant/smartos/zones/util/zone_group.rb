require 'vagrant/smartos/zones/models/zone_group'
require 'vagrant/smartos/zones/util/global_zone/helper'

module Vagrant
  module Smartos
    module Zones
      module Util
        class ZoneGroup
          include GlobalZone::Helper

          attr_reader :machine, :zone

          def initialize(machine, zone)
            @machine = machine
            @zone = zone
          end

          def find(group)
            Models::ZoneGroup.new.tap do |g|
              g.name = group
              with_gz("#{sudo} zlogin #{zone.uuid} gid -g #{group}") do |output|
                g.gid = output.chomp if output
              end
            end
          end

          def exists?(group)
            machine.communicate.gz_test("#{sudo} zlogin #{zone.uuid} gid -g #{group}")
          end

          def create(group)
            return if exists?(group)
            zone.zlogin("groupadd #{group}")
          end
        end
      end
    end
  end
end
