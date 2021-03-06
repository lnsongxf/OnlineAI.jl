
# __precompile__()

module OnlineAI

using Reexport
using Distributions
@reexport using QuickStructs
@reexport using OnlineStats
#@reexport using Qwt
#@reexport using CTechCommon
# using StatsBase
@reexport using StatsBase
# using Plots
using Requires
using ArrayViews
using Plots
@reexport using LearnBase
import LearnBase: value

import OnlineStats: nrows, ncols,
                    VecF, MatF, AVecF, AMatF,
                    standardize

export row, col, row!, col!, rows, cols, nrows, ncols,
       VecF, MatF, AVecF, AMatF,
       standardize



# represents a node in an arbitrary graph... typically representing a neuron within a neural net
abstract NetStat <: OnlineStat
nobs(o::NetStat) = 0
abstract AbstractNeuron

abstract NeuralNetLayer

# ------------------------------------------------

include("utils.jl")

# export
#   Mapping,
#   IdentityMapping,
#   SigmoidMapping,
#   TanhMapping,
#   SoftsignMapping,
#   ReLUMapping,
#   LReLUMapping,
#   SoftmaxMapping
# include("nnet/activations.jl")

export
  DataPoint,
  Transformation,
  IdentityTransform,
  AbsTransform,
  LogPlus1Transform,
  SquareTransform,
  CubeTransform,
  SignSquareTransform,
  Transformer,
  IdentityTransformer,
  VectorTransformer,
  transform,
  transform!,
  DataPoints,
  splitDataPoints,
  DataSampler,
  SimpleSampler,
  SubsetSampler,
  splitDataSamplers,
  StratifiedSampler,
  crossValidationSets
include("nnet/data.jl")

export
  cost,
  totalCost
include("nnet/costs.jl")

export
  current_updater,
  current_mloss,
  current_ploss,
  current_updater!,
  current_mloss!,
  current_ploss!,
  LearningRateModel,
  FixedLearningRate,
  AdaptiveLearningRate
include("nnet/gradient.jl")

export
  DropoutStrategy,
  Dropout,
  NoDropout,
  NetParams
include("nnet/params.jl")

export
  SolverParams,
  SolverStats,
  solve!
include("nnet/solver.jl")

export
  NeuralNetLayer,
  Layer,
  # forward,
  # backward,
  forward!,
  backward!
include("nnet/layer.jl")

export
  NormalizedLayer
include("nnet/normlayer.jl")

export
  NeuralNet
include("nnet/net.jl")

export
  pretrain
include("nnet/pretrain.jl")

# include("nnet/lstm.jl")

export
  buildNet,
  buildClassificationNet,
  buildTanhClassificationNet,
  buildRegressionNet
include("nnet/build.jl")

export
  Constant,
  HiddenLayerSampler,
  VectorSampler,
  ParameterSampler,
  generateTransformer,
  generateModels,
  Ensemble
include("nnet/ensembles.jl")

# export
#   visualize,
#   track_progress

# function __init__()

# include("nnet/visualize.jl")

# ----------------------------------------------------------------------

# NOTE: EXPERIMENTAL

export
  GaussianReceptiveField,
  # value,
  Synapse,
  DelaySynapse,
  fire!,    # checks for threshold crossing, then fires
  SpikingNeuron,
  DiscreteLeakyIntegrateAndFireNeuron,
  LiquidParams,
  Liquid,

  ImmediateSynapse,
  GRFNeuron,
  GRFInput,
  LiquidInput,
  LiquidInputs,

  Readout,
  FireReadout,
  StateReadout,
  FireWindowReadout,

  LiquidStateMachine,
  liquidState,

  LiquidVisualization,
  LiquidVisualizationNode

abstract Synapse
abstract SpikingNeuron <: AbstractNeuron
abstract LiquidInput


include("spiking/readout.jl")
include("spiking/liquid.jl")
include("spiking/srm.jl")
include("spiking/input.jl")
# include("spiking/visualize.jl")

include("spiking/skan.jl")

# ------------------------------------------------

end
