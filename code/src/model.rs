use crate::batcher::WineBatch;
use burn::config::Config;
use burn::module::Module;
use burn::nn::loss::CrossEntropyLossConfig;
use burn::nn::{Dropout, DropoutConfig, LeakyRelu, LeakyReluConfig, Linear, LinearConfig, Relu};
use burn::prelude::{Backend, Tensor};
use burn::tensor::backend::AutodiffBackend;
use burn::tensor::Int;
use burn::train::{ClassificationOutput, TrainOutput, TrainStep, ValidStep};

#[derive(Module, Debug)]
pub struct WineModel<B: Backend> {
    input_layer: Linear<B>,
    hidden_layer: Linear<B>,
    output_layer: Linear<B>,
    activation: Relu,
    activation_2: LeakyRelu,
    dropout: Dropout,
}

impl<B: Backend> WineModel<B> {
    pub fn forward(&self, x: Tensor<B, 2>) -> Tensor<B, 2> {
        let x = self.input_layer.forward(x);
        let x = self.activation_2.forward(x);
        let x = self.dropout.forward(x);

        let x = self.hidden_layer.forward(x);
        let x = self.activation_2.forward(x);
        let x = self.dropout.forward(x);

        self.output_layer.forward(x)
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
            input_layer: LinearConfig::new(13, self.hidden_size).init(device),
            hidden_layer: LinearConfig::new(self.hidden_size, self.hidden_size / 2).init(device),
            output_layer: LinearConfig::new(self.hidden_size / 2, self.num_classes).init(device),
            activation: Relu::new(),
            activation_2: LeakyReluConfig::new().with_negative_slope(0.01).init(),
            dropout: DropoutConfig::new(self.dropout).init(),
        }
    }
}
