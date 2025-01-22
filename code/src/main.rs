use burn::{
    backend::{Autodiff, Wgpu},
    optim::AdamConfig,
};
use si_project::model::WineModelConfig;
use si_project::training::{train, TrainingConfig};

fn main() {
    type MyBackend = Wgpu<f32, i32>;
    type MyAutodiffBackend = Autodiff<MyBackend>;

    let device = burn::backend::wgpu::WgpuDevice::default();
    let artifact_dir = "./artifacts";
    train::<MyAutodiffBackend>(
        artifact_dir,
        TrainingConfig::new(WineModelConfig::new(10, 512), AdamConfig::new()),
        device.clone(),
    );
}