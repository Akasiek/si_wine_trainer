#[derive(Debug, PartialEq, Clone)]
#[repr(C)]
pub struct Wine {
    pub class: i32,
    pub alcohol: f32,
    pub malic_acid: f32,
    pub ash: f32,
    pub alcalinity_of_ash: f32,
    pub magnesium: f32,
    pub total_phenols: f32,
    pub flavanoids: f32,
    pub nonflavanoid_phenols: f32,
    pub proanthocyanins: f32,
    pub color_intensity: f32,
    pub hue: f32,
    pub od280_od315_of_diluted_wines: f32,
    pub proline: f32,
}
