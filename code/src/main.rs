use burn::backend::cuda_jit::CudaDevice;
use burn::backend::{CudaJit};
use burn::data::dataset::Dataset;
use burn::{
    backend::{Autodiff, Wgpu},
    optim::AdamConfig,
};
use si_project::dataset::WineDataset;
use si_project::inference::infer;
use si_project::model::WineModelConfig;
use si_project::training::{train, TrainingConfig};

fn main() {
    // type MyBackend = Wgpu<f32, i32>;
    type MyBackend = CudaJit<f32, i32>;
    type MyAutodiffBackend = Autodiff<MyBackend>;

    // let device = burn::backend::wgpu::WgpuDevice::default();
    let device = CudaDevice::default();
    let artifact_dir = "./artifacts";
    train::<MyAutodiffBackend>(
        artifact_dir,
        TrainingConfig::new(WineModelConfig::new(3, 111), AdamConfig::new()),
        device.clone(),
    );

    infer::<MyBackend>(
        artifact_dir,
        device.clone(),
        WineDataset::test().get(0).unwrap(),
    );
}
