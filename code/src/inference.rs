use burn::config::Config;
use burn::data::dataloader::batcher::Batcher;
use burn::module::Module;
use burn::prelude::Backend;
use burn::record::{CompactRecorder, Recorder};
use crate::batcher::WineBatcher;
use crate::training::TrainingConfig;
use crate::dataset::WineItem;

pub fn infer<B: Backend>(artifact_dir: &str, device: B::Device, item: WineItem) {
    let config = TrainingConfig::load(format!("{artifact_dir}/config.json"))
        .expect("Config should exist for the model");
    let record = CompactRecorder::new()
        .load(format!("{artifact_dir}/model").into(), &device)
        .expect("Trained model should exist");

    let model = config.model.init::<B>(&device).load_record(record);

    let label = item.class;
    let batcher = WineBatcher::new(device);
    let batch = batcher.batch(vec![item]);
    let output = model.forward(batch.x);
    let predicted = output.argmax(1).flatten::<1>(0, 1).into_scalar();

    println!("Predicted {} Expected {}", predicted, label);
}