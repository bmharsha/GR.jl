using BinaryProvider

download_info = Dict(
    "MacOS" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Darwin-x86_64.tar.gz", "49931a0d14ec3f33e91739836539bc9c6f218024f2dd786349b0b38b3cad436510dc0431dcde4c445fa80ff0ff85b06f74effda3df9932184131d32302cce51d"),
    "CentOS" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-CentOS-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b065cae41421c4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "Debian" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Debian-x86_64.tar.gz", "b87aba569a80d6a94050dd359c3a8a5f1aa5a2519c0e0565cc91dbb3cd7721c687fef8bb907ace2caa4ee9b27d9ac45bbdfacb6e104af07102f687dfa58904cb"),
	"i386" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Linux-i386.tar.gz", "eb72793b924f5e4e662cf9275e8a06566a43ec964152548bec80166ba49b8f98865ab322627e44abf33497a7af2875a213a3b04853e03acaeeb0d12fd399bca6"),
	"x86_64" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Linux-x86_64.tar.gz", "e5cb237c1f09ee087decba70b062c64b4b280ff6fd31ceaf566c1667faf7d2049d36646171051b8e153de38d7ffab3699e8af3ba00b87c595f1777bf0ef33dc7"),
	"Redhat" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Redhat-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b065cae41421c4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
	"Ubuntu" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Ubuntu-x86_64.tar.gz", "2b2b569168615c913c00ffc1a4782158c870bf5f217a0e4a7b72d8aecba985c238900b347dcd9598d7d62ca72adc681444fd6f996ea31e63269f0175f7cfdd6d"),
	"JS" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0.js", ""),
	"SHA" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0.sha512.txt", ""),	
    "Windows_x86_64" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Windows-x86_64.tar.gz", "59400f7a167a2a8a7400eb9fa137fa533fc41b2e8caad1775ddb8628f46525889098656d1154babd6966fb39c504ea33177b0457f8b410a72b7664f568b6dda2"),
    "Windows_i686" => ("https://github.com/sciapp/gr/releases/download/v0.39.0/gr-0.39.0-Windows-i686.tar.gz", "97422510b2867dd6f75fb9b2970344f8600afd451743bd4b3ca5e5ad405fc0b69933bb4ba531176039b6d25c43f9c60c4137b58be480f67843760bdbe284d377"),
)

@static if !isdefined(Base, Symbol("@info"))
    macro info(msg)
        return :(info($(esc(msg))))
    end
end

@static if VERSION >= v"0.7.0-DEV.3656"
    using Pkg.API: installed
end

function check_grdir()
    if "GRDIR" in keys(ENV)
        grdir = ENV["GRDIR"]
        have_dir = length(grdir) > 0
        if have_dir
            have_dir = isdir(joinpath(grdir, "fonts"))
        end
    else
        have_dir = false
        for d in (homedir(), "/opt", "/usr/local", "/usr")
            grdir = joinpath(d, "gr")
            if isdir(joinpath(grdir, "fonts"))
                have_dir = true
                break
            end
        end
    end
    if have_dir
        @info "Found exisitng GR run-time in $grdir"
    end
    have_dir
end

function get_version()
    version = v"0.39.0"
    try
@static if VERSION >= v"0.7.0-DEV.3656"
        v = installed()["GR"]
else
        v = Pkg.installed("GR")
end
        if string(v)[end:end] == "+"
            version = "latest"
        end
    catch
    end
    version
end

function get_os_release(key)
    value = try
        String(read(pipeline(`cat /etc/os-release`, `grep ^$key=`, `cut -d= -f2`)))[1:end-1]
    catch
        ""
    end
    if VERSION < v"0.7-"
        replace(value, "\"", "")
    else
        replace(value, "\"" => "")
    end
end

if !check_grdir()
  if Sys.KERNEL == :NT
    os = :Windows
  else
    os = Sys.KERNEL
  end
  arch = Sys.ARCH
  if os == :Linux && arch == :x86_64
    if isfile("/etc/redhat-release")
      rel = String(read(pipeline(`cat /etc/redhat-release`, `sed s/.\*release\ //`, `sed s/\ .\*//`)))[1:end-1]
      if rel > "7.0"
        os = "Redhat"
      end
    elseif isfile("/etc/os-release")
      id = get_os_release("ID")
      id_like = get_os_release("ID_LIKE")
      if id == "ubuntu" || id_like == "ubuntu"
        os = "Ubuntu"
      elseif id == "debian" || id_like == "debian"
        os = "Debian"
      end
    end
  elseif os == :Linux && arch in [:i386, :i686]
    arch = :i386
  end
  version = get_version()
  tarball = "gr-$version-$os-$arch.tar.gz"
  rm("downloads", force=true, recursive=true)
  @info("Downloading pre-compiled GR $version $os binary")
  mkpath("downloads")
  file = "downloads/$tarball"
  try
    url = ENV["JULIA_PKG_SERVER"] * "/binary/gr/v0.39.0/$tarball"
    BinaryProvider.download(url,file)
  catch
    url = "gr-framework.org/downloads/$tarball"
    try
      download("https://$url", file)
    catch
        @info("Cannot download GR run-time")
    end
  end
  if os == :Windows
    home = (VERSION < v"0.7-") ? JULIA_HOME : Sys.BINDIR
    success(`$home/7z x downloads/$tarball -y`)
    rm("downloads/$tarball")
    tarball = tarball[1:end-3]
    success(`$home/7z x $tarball -y -ttar`)
    rm(tarball)
  else
    run(`tar xzf downloads/$tarball`)
    rm("downloads/$tarball")
  end
  if os == :Darwin
    app = joinpath("gr", "Applications", "GKSTerm.app")
    run(`/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f $app`)
    try
@static if VERSION >= v"0.7.0-DEV.3656"
      have_qml = haskey(installed(), "QML")
else
      have_qml = Pkg.installed("QML") != nothing
end
      if have_qml
        @eval import QML
        qt = QML.qt_prefix_path()
        path = joinpath(qt, "Frameworks")
        if isdir(path)
          qt5plugin = joinpath(pwd(), "gr", "lib", "qt5plugin.so")
          run(`install_name_tool -add_rpath $path $qt5plugin`)
          println("Using Qt ", splitdir(qt)[end], " at ", qt)
        end
      end
    catch
    end
  end
end
