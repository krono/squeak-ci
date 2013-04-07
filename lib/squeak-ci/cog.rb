require_relative 'utils'

class CogVersion
  attr_reader :week, :year, :svnid
  def initialize(week_int, year_int, svnid)
    @week = week_int
    @year = year_int
    @svnid = svnid
  end

  def to_s
    "#{week}.#{year}"
  end

  def version_string
    "#{week}.#{year}.#{svnid}"
  end

  def filename(os_name, vm_type)
    basename = if os_name == "osx" then
                 case vm_type
                 when :normal then "Cog.app"
                 when :mt then "CogMT.app"
                 else
                   raise "Unknown vm_type #{vm_type.inspect} passed to CogVersion#filename"
                 end
               else
                 dir_name(vm_type)
               end
    case os_name
    when "linux", "linux64" then "#{basename}linux-#{version_string}.tgz"
    when "windows" then "#{basename}win-#{version_string}.zip"
    when "osx" then "#{basename}-#{version_string}.tgz"
    end
  end

  def cog_location(base_path, os_name, vm_type = :normal)
    base_name = dir_name(vm_type)
    case os_name
    when "linux", "linux64" then base_path + "#{base_name}.r#{svnid}/#{base_name}linux/bin/squeak"
    when "windows" then base_path + "#{base_name}.r#{svnid}/#{base_name}win/Croquet.exe"
    when "osx" then log("CogVersion#cog_location not implemented for #{os_name}")
    else
      nil
    end
  end

  def dir_name(vm_type)
    case vm_type
    when :normal then 'cog'
    when :mt then 'cogmt'
    else
      raise "Unknown vm_type #{vm_type.inspect} given to CogVersion#dir_name"
    end
  end
end
