void f(){
    float *A = (float*)malloc(4*sizeof(float));
    float *B = (float*)malloc(4*sizeof(float));
    float *C = (float*)malloc(4*sizeof(float));
    A[0] = -0.259093;
    A[1] = -1.498961;
    A[2] = 0.119264;
    A[3] = 0.458181;
    B[0] = 0.394975;
    B[1] = 0.044197;
    B[2] = -0.636256;
    B[3] = 1.731264;


    constexpr float alpha = 1;
    constexpr float beta = 0;
    constexpr int m = 2;
    constexpr int k = 2;
    constexpr int n = 2;
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, A, 2, B, 2, beta, C, 2);
    std::cout << C[0] << " " << C[1] << std::endl;
    std::cout << C[2] << " " << C[3] << std::endl;
}
