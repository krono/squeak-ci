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
    "#{year}.#{week.to_s.rjust(2,"0")}.#{svnid}"
  end

  def filename(os_name, vm_type)
    basename = dir_name(os_name, vm_type)
    case os_name
    when "linux", "linux64" then
      if ht? vm_type then
        "#{basename}linuxht-#{version_string}.tgz" # Note the "ht" suffix
      else
        "#{basename}linux-#{version_string}.tgz"
      end
    when "windows" then "#{basename}win-#{version_string}.zip"
    when "osx"     then "#{basename}-#{version_string}.tgz"
    end
  end

  def ht? vm_type
    [:spur, :mtht, :ht].include? vm_type
  end

  def lib_dir(base_path, os_name, vm_type = :normal)
    base_name = dir_name(os_name, vm_type)
    case os_name
    when "linux", "linux64" then base_path + "#{base_name}.r#{svnid}/#{base_name}linux/lib"
    when "windows" then base_path + "#{base_name}.r#{svnid}/#{base_name}win/"
    when "osx" then base_path + "#{base_name}.r#{svnid}/#{base_name}/Contents/MacOS/"
    else
      nil
    end
  end

  def cog_location(base_path, os_name, vm_type = :normal)
    base_name = dir_name(os_name, vm_type)
    case os_name
    when "linux", "linux64" then
      if ht? vm_type then
        base_path + "#{base_name}.r#{svnid}/#{base_name}linuxht/bin/squeak"
      else
        base_path + "#{base_name}.r#{svnid}/#{base_name}linux/bin/squeak"
      end
    when "windows" then base_path + "#{base_name}.r#{svnid}/#{base_name}win/SqueakConsole.exe"
    when "osx"     then base_path + "#{base_name}.r#{svnid}/#{base_name}/Contents/MacOS/Squeak"
    else
      nil
    end
  end

  def dir_name(os_name, vm_type)
    if os_name == "osx" then
      case vm_type
      when :normal then "Cog.app"
      when :ht     then "Cog.app"
      when :mt     then "CogMT.app"
      when :mtht   then "CogMT.app"
      when :spur   then "CogSpur.app"
      else
        raise "Unknown vm_type #{vm_type.inspect} for 'osx' passed to CogVersion#dir_name"
      end
    else
      case vm_type
      when :normal then 'cog'
      when :ht     then 'cog'
      when :mt     then 'cogmt'
      when :mtht   then 'cogmt'
      when :spur   then 'cogspur'
      else
        raise "Unknown vm_type #{vm_type.inspect} for '#{os_name}' given to CogVersion#dir_name"
      end
    end
  end
end
