
function buildNet(numInputs::Integer, numOutputs::Integer, hiddenStructure::AVec{Int};
                  hiddenActivation::Activation = SigmoidActivation(),
                  finalActivation::Activation = SigmoidActivation(),
                  params = NetParams(),
                  solverParams = SolverParams(),
                  inputTransformer::Transformer = IdentityTransformer(),
                  wgt::Weight = EqualWeight())
  layers = LAYER[]
  nin = numInputs

  # the first layer will get the "input" dropout probability
  pDropout = getDropoutProb(params, true)

  for nout in hiddenStructure

    # push the hidden layer
    push!(layers, LAYER(nin,
                        nout,
                        hiddenActivation,
                        params.gradientModel,
                        pDropout;
                        wgt = wgt,
                        weightInit = params.weightInit
                       ))
    nin = nout
    
    # next layers will get the "hidden" dropout probability
    pDropout = getDropoutProb(params, false)
  end

  # push the output layer
  push!(layers, LAYER(nin,
                      numOutputs,
                      finalActivation,
                      params.gradientModel,
                      pDropout;
                      wgt = wgt,
                      weightInit = params.weightInit
                     ))

  NeuralNet(layers, params, solverParams, inputTransformer)
end

buildClassificationNet(args...; kwargs...) = buildNet(args...; kwargs..., finalActivation = SigmoidActivation())
buildTanhClassificationNet(args...; kwargs...) = buildNet(args...; kwargs..., hiddenActivation = TanhActivation(), finalActivation = TanhActivation())
buildRegressionNet(args...; kwargs...) = buildNet(args...; kwargs..., finalActivation = IdentityActivation())