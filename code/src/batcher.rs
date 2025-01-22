use crate::dataset::WineItem;
use burn::data::dataloader::batcher::Batcher;
use burn::prelude::{Backend, Int, Tensor};

#[derive(Clone)]
pub struct WineBatcher<B: Backend> {
    device: B::Device,
}

impl<B: Backend> WineBatcher<B> {
    pub fn new(device: B::Device) -> Self {
        Self { device }
    }
}

#[derive(Clone, Debug)]
pub struct WineBatch<B: Backend> {
    pub x: Tensor<B, 2>,
    pub y: Tensor<B, 1, Int>,
}

impl<B: Backend> Batcher<WineItem, WineBatch<B>> for WineBatcher<B> {
    fn batch(&self, data: Vec<WineItem>) -> WineBatch<B> {
        let x = data
            .iter()
            .map(|wine| {
                Tensor::<B, 2>::from_data(
                    [[
                        wine.alcohol,
                        wine.malic_acid,
                        wine.ash,
                        wine.alcalinity_of_ash,
                        wine.magnesium,
                        wine.total_phenols,
                        wine.flavanoids,
                        wine.nonflavanoid_phenols,
                        wine.proanthocyanins,
                        wine.color_intensity,
                        wine.hue,
                        wine.od280_od315_of_diluted_wines,
                        wine.proline,
                    ]],
                    &self.device,
                )
            })
            .collect::<Vec<_>>();

        let y = data
            .iter()
            .map(|wine| Tensor::<B, 1, Int>::from_data([wine.class], &self.device))
            .collect::<Vec<_>>();

        let x = Tensor::<B, 2>::cat(x, 0).to_device(&self.device);
        let y = Tensor::<B, 1, Int>::cat(y, 0).to_device(&self.device);

        WineBatch { x, y }
    }
}
