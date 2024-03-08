macro mustimplement(sig)
    fname = sig.args[1]
    arg1 = sig.args[2]

    if isa(arg1, Expr)
        arg1 = arg1.args[2]
    end

    :($(esc(sig)) = error("$($(Expr(:quote, sig))) is part of the required interface for $($(Expr(:quote, arg1))) but has not been implemented"))
end