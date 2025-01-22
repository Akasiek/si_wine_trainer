use crate::batcher::WineBatch;
use burn::config::Config;
use burn::module::Module;
use burn::nn::{Dropout, DropoutConfig, Linear, LinearConfig, Relu};
use burn::nn::loss::CrossEntropyLossConfig;
use burn::prelude::{Backend, Tensor};
use burn::tensor::backend::AutodiffBackend;
use burn::tensor::Int;
use burn::train::{ClassificationOutput, TrainOutput, TrainStep, ValidStep};
use crate::wine::WineBatch;

#[derive(Module, Debug)]
pub struct WineModel<B: Backend> {
    linear1: Linear<B>,
    linear2: Linear<B>,
    linear3: Linear<B>,
    relu: Relu,
    dropout: Dropout,
}

impl<B: Backend> WineModel<B> {
    pub fn forward(&self, x: Tensor<B, 2>) -> Tensor<B, 2> {
        let x = self.linear1.forward(x);
        let x = self.relu.forward(x);
        let x = self.dropout.forward(x);
        let x = self.linear2.forward(x);
        let x = self.relu.forward(x);
        self.linear3.forward(x)
    }
}

impl<B: Backend> WineModel<B> {
    pub fn forward_classification(
        &self,
        x: Tensor<B, 2>,
        y: Tensor<B, 1, Int>,
    ) -> ClassificationOutput<B> {
        let output = self.forward(x);
        let loss = CrossEntropyLossConfig::new()
            .init(&output.device())
            .forward(output.clone(), y.clone());

        ClassificationOutput::new(loss, output, y)
    }
}

impl<B: AutodiffBackend> TrainStep<WineBatch<B>, ClassificationOutput<B>> for WineModel<B> {
    fn step(&self, batch: WineBatch<B>) -> TrainOutput<ClassificationOutput<B>> {
        let item = self.forward_classification(batch.x, batch.y);

        TrainOutput::new(self, item.loss.backward(), item)
    }
}

impl<B: Backend> ValidStep<WineBatch<B>, ClassificationOutput<B>> for WineModel<B> {
    fn step(&self, batch: WineBatch<B>) -> ClassificationOutput<B> {
        self.forward_classification(batch.x, batch.y)
    }
}

#[derive(Config, Debug)]
pub struct WineModelConfig {
    num_classes: usize,
    hidden_size: usize,
    #[config(default = "0.5")]
    dropout: f64,
}

impl WineModelConfig {
    pub fn init<B: Backend>(&self, device: &B::Device) -> WineModel<B> {
        WineModel {
            linear1: LinearConfig::new(13, 128).init(device),
            linear2: LinearConfig::new(128, 64).init(device),
            linear3: LinearConfig::new(64, 3).init(device),
            relu: Relu::new(),
            dropout: DropoutConfig::new(self.dropout).init(),
        }
    }
}

