show_fix2(io::IO, f::Base.Fix2) = print(io, f.f, "(", f.x, ")")
Base.print(io::IO, f::Base.Fix2) = show_fix2(io, f)
Base.show(io::IO, ::MIME"text/plain", f::Base.Fix2) = show_fix2(io, f)
