require_relative 'utils'

class CogVersion
  attr_reader :year, :week, :svnid
  # Year, week are integers
  def initialize(year_int, week_int, svnid)
    @year = year_int
    @week = week_int
    @svnid = svnid
  end

  def to_s
    "#{year}.#{week}"
  end

  def version_string
    "#{year}.#{week}.#{svnid}"
  end

  def filename(os_name, vm_type)
    basename = dir_name(os_name, vm_type)
    case os_name
    when "linux", "linux64" then "#{basename}linux-#{version_string}.tgz"
    when "windows" then "#{basename}win-#{version_string}.zip"
    when "osx" then "#{basename}-#{version_string}.tgz"
    end
  end

  def cog_location(base_path, os_name, vm_type = :normal)
    base_name = dir_name(os_name, vm_type)
    case os_name
    when "linux", "linux64" then base_path + "#{base_name}.r#{svnid}/#{base_name}linux/bin/squeak"
    when "windows" then base_path + "#{base_name}.r#{svnid}/#{base_name}win/Squeak.exe"
    when "osx" then base_path + "#{base_name}.r#{svnid}/#{base_name}/Contents/MacOS/Squeak"
    else
      nil
    end
  end

  def dir_name(os_name, vm_type)
    if os_name == "osx" then
      case vm_type
      when :normal then "Cog.app"
      when :mt then "CogMT.app"
      else
        raise "Unknown vm_type #{vm_type.inspect} for 'osx' passed to CogVersion#dir_name"
      end
    else
      case vm_type
      when :normal then 'cog'
      when :mt then 'cogmt'
      else
        raise "Unknown vm_type #{vm_type.inspect} for '#{os_name}' given to CogVersion#dir_name"
      end
    end
  end
end
