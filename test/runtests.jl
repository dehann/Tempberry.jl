using Base: Test
using Tempberry

import Tempberry: maketemptable

@testset "HTML functions" begin

maketemptable(now(), 1.0, 2.0)
@test true


end
