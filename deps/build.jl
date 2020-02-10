using Pkg

download_info = Dict(
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-ArchLinux-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-CentOS-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Darwin-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Debian-armhf.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Debian-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Linux-i386.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Redhat-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Ubuntu-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Windows-i686.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Windows-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0-Windows-x86_64.tar.gz", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0.js", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/GR.jl/releases/download/v0.44.90/gr-0.44.0.sha512.txt", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
)


@static if !isdefined(Base, Symbol("@info"))
    macro info(msg)
        return :(info($(esc(msg))))
    end
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
    version = v"0.44.0"
    try
@static if VERSION >= v"1.4.0-DEV.265"
        v = string(Pkg.dependencies()[Base.UUID("28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71")].version)
else
        v = Pkg.API.installed()["GR"]
end
    catch
    end
    if "GRDIR" in keys(ENV)
        if length(ENV["GRDIR"]) == 0
            version = "latest"
        end
    end
    version
end

function get_os_release(key)
    value = try
        String(read(pipeline(`cat /etc/os-release`, `grep ^$key=`, `cut -d= -f2`)))[1:end-1]
    catch
        ""
    end
    replace(value, "\"" => "")
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
      elseif id == "arch" || id_like == "arch"
        os = "ArchLinux"
      end
    end
  elseif os == :Linux && arch in [:i386, :i686]
    arch = :i386
  elseif os == :Linux && arch == :arm
    id = get_os_release("ID")
    if id == "raspbian"
      os = "Debian"
    end
    arch = "armhf"
  end
  version = get_version()
  tarball = "gr-$version-$os-$arch.tar.gz"
  rm("downloads", force=true, recursive=true)
  @info("Downloading pre-compiled GR $version $os binary")
  mkpath("downloads")
  file = "downloads/$tarball"
  try
    url = Pkg.pkg_server() * "/binary/GR.jl/v0.44.90/$tarball"
    Pkg.PlatformEngines.probe_platform_engines!()
    Pkg.PlatformEngines.download(url,file)
  catch
    url = "gr-framework.org/downloads/$tarball"
    try
      download("https://$url", file)
    catch
      @info("Using insecure connection")
      try
        download("http://$url", file)
      catch
        @info("Cannot download GR run-time")
      end
    end
  end
  if os == :Windows
    home = Sys.BINDIR
    if VERSION > v"1.3.0-"
      home =  joinpath(Sys.BINDIR, "..", "libexec")
    end
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
@static if VERSION >= v"1.4.0-DEV.265"
      have_qml = haskey(Pkg.dependencies(),Base.UUID("2db162a6-7e43-52c3-8d84-290c1c42d82a"))
else
      have_qml = haskey(Pkg.API.installed(), "QML")
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
