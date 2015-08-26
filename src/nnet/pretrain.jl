



doc"""
A framework for pretraining neural nets (alternative to random weight initialization).
I expect to implement Deep Belief Net pretraining using Stacked Restricted Boltzmann Machines (RBM)
and Stacked Sparse (Denoising) Autoencoders.
"""
abstract PretrainStrategy


# default
pretrain(net::NeuralNet, sampler::DataSampler; kwargs...) = pretrain(DenoisingAutoencoder, net, sampler; kwargs...)

# -----------------------------------------------------------------

immutable DenoisingAutoencoder <: PretrainStrategy end



function pretrain(::Type{DenoisingAutoencoder}, net::NeuralNet, sampler::DataSampler;
                    tiedweights::Bool = true,
                    maxiter::Int = 1000,
                    dropout::DropoutStrategy = Dropout(pInput=0.7,pHidden=0.0),  # this is the "denoising" part, which throws out some of the inputs
                    encoderParams::NetParams = NetParams(η=0.1, μ=0.0, λ=0.0001, dropout=dropout),
                    solverParams::SolverParams = SolverParams(maxiter=maxiter, erroriter=typemax(Int), breakiter=typemax(Int)),  #probably don't set this manually??
                    inputActivation::Activation = IdentityActivation())

  # lets pre-load the input dataset for simplicity... just need the x vec, since we're trying to map: x --> somthing --> x
  dps = DataPoints([DataPoint(dp.x, dp.x) for dp in DataPoints(sampler)])
  # println(dps)
  sampler = SimpleSampler(dps)

  # for each layer (which is not the output layer), fit the weights/bias as guided by the pretrain strategy
  for layer in net.layers[1:end-1]

    # build a neural net which maps: nin -> nout -> nin
    outputActivation = layer.activation
    autoencoder = buildNet(layer.nin, layer.nin, [layer.nout]; hiddenActivation=inputActivation, finalActivation=outputActivation, params=encoderParams)

    # tied weights means w₂ = w₁' ... rebuild the layer with a TransposeView of the first layer's weights
    l1, l2 = autoencoder.layers
    if tiedweights
      autoencoder.layers[2] = Layer(l2.nin, l2.nout, l2.activation, l2.p, l2.x, TransposeView(l1.w), l2.dw, l2.b, l2.db, l2.δ, l2.Σ, l2.r, l2.nextr, TransposeView(l1.Gw), l2.Gb)
    end

    println("netlayer: $layer  oact: $outputActivation  autoenc: $autoencoder")

    # solve for the weights and bias... note we're not using stopping criteria... only maxiter
    stats = solve!(autoencoder, solverParams, sampler, sampler)
    println("  $stats")

    # save the weights and bias to the layer
    # println("l1: $l1")
    layer.w = l1.w
    layer.b = l1.b

    # update the inputActivation, so that this layer's activation becomes the next autoencoder's inputActivation
    inputActivation = outputActivation

    # feed the data forward to the next layer
    for i in 1:length(dps)
      newx = forward(l1, dps[i].x, false)
      dps[i] = DataPoint(newx, newx)
    end
    # println(dps)

  end

  # we're done... net is pretrained now
  return
end

