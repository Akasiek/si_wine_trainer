use crate::model::WineModelConfig;
use crate::dataset::WineDataset;
use burn::config::Config;
use burn::data::dataloader::DataLoaderBuilder;
use burn::module::Module;
use burn::optim::AdamConfig;
use burn::record::CompactRecorder;
use burn::tensor::backend::AutodiffBackend;
use burn::train::metric::{AccuracyMetric, LossMetric};
use burn::train::{LearnerBuilder};
use crate::batcher::WineBatcher;

#[derive(Config)]
pub struct TrainingConfig {
    pub model: WineModelConfig,
    pub optimizer: AdamConfig,
    #[config(default = 300)]
    pub num_epochs: usize,
    #[config(default = 16)]
    pub batch_size: usize,
    #[config(default = 8)]
    pub num_workers: usize,
    #[config(default = 42)]
    pub seed: u64,
    #[config(default = 1.0e-5)]
    pub learning_rate: f64,
}

pub fn train<B: AutodiffBackend>(artifact_dir: &str, config: TrainingConfig, device: B::Device) {
    create_artifact_dir(artifact_dir);
    config
        .save(format!("{artifact_dir}/config.json"))
        .expect("Config should be saved successfully");

    B::seed(config.seed);

    let train_batch = WineBatcher::<B>::new(device.clone());
    let test_batch = WineBatcher::<B::InnerBackend>::new(device.clone());

    let dataloader_train = DataLoaderBuilder::new(train_batch)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WineDataset::train());

    let dataloader_test = DataLoaderBuilder::new(test_batch)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WineDataset::test());

    let learner = LearnerBuilder::new(artifact_dir)
        .metric_train_numeric(AccuracyMetric::new())
        .metric_valid_numeric(AccuracyMetric::new())
        .metric_train_numeric(LossMetric::new())
        .metric_valid_numeric(LossMetric::new())
        .with_file_checkpointer(CompactRecorder::new())
        .devices(vec![device.clone()])
        .num_epochs(config.num_epochs)
        .summary()
        .build(
            config.model.init::<B>(&device),
            config.optimizer.init(),
            config.learning_rate,
        );

    let model_trained = learner.fit(dataloader_train, dataloader_test);

    model_trained
        .save_file(format!("{artifact_dir}/model"), &CompactRecorder::new())
        .expect("Trained model should be saved successfully");
}

fn create_artifact_dir(artifact_dir: &str) {
    // Remove existing artifacts before to get an accurate learner summary
    std::fs::remove_dir_all(artifact_dir).ok();
    std::fs::create_dir_all(artifact_dir).ok();
}
