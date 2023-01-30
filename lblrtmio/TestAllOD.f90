program main

    USE Type_Kinds           , ONLY: FP, IP, DP => Double
    USE LBLRTMIO_Module

    IMPLICIT NONE

    TYPE(LBLRTM_File_type) :: ofile
    INTEGER err_stat
    INTEGER:: i, n
    REAL(DP), ALLOCATABLE :: frequency(:)
    REAL(DP), ALLOCATABLE :: spectrum (:)
    REAL(DP), ALLOCATABLE :: transmission(:)
    REAL(DP) :: SUM1,SUM2
    CHARACTER(LEN=11) :: FNAME
    CHARACTER(LEN=1)  :: ONECHAR
    CHARACTER(LEN=2)  :: TWOCHAR
    INTEGER :: NFILES

    print *, 'Test lblrtmio with ODdeflt_001-ODdeflt_062 '
    print *, 'READ AND CALCULATE WITH ODdeflt files'

    NFILES=62
    DO I=1,NFILES
        FNAME(1:8)="ODdeflt_"
        IF (I<10) THEN
            WRITE(ONECHAR,'(I1)') I
            FNAME(9:10)="__"
            FNAME(11:11)=ONECHAR
        ELSE
            WRITE(TWOCHAR,'(I2)') I
            FNAME(9:9)="_"
            FNAME(10:11)=TWOCHAR
        ENDIF
        PRINT *, I, FNAME
    ENDDO
end program main

SUBROUTINE ParseFile


    USE Type_Kinds           , ONLY: FP, IP, DP => Double
    USE LBLRTMIO_Module

    IMPLICIT NONE

    TYPE(LBLRTM_File_type) :: ofile
    INTEGER err_stat
    INTEGER:: i, n
    REAL(DP), ALLOCATABLE :: frequency(:)
    REAL(DP), ALLOCATABLE :: spectrum (:)
    REAL(DP), ALLOCATABLE :: transmission(:)
    REAL(DP) :: SUM1,SUM2
    CHARACTER(LEN=11) :: FNAME


    err_stat = LBLRTM_File_Read(ofile, "ODdeflt_022")
    !err_stat = LBLRTM_File_Read(ofile, "TAPE3")
    !    err_stat = LBLRTM_File_Read(ofile, "TAPE12")
    IF ( err_stat /= SUCCESS ) THEN
        print *, "handle error..."
    END IF
    print *, "N layers=", ofile%n_Layers
    print *, "N spectra=", ofile%Layer(1)%n_Spectra
    print *, "N points=", ofile%Layer(1)%n_Points
    do i=1,10
        print *, i,  oFile%Layer(1)%Spectrum(i,1)
    end do

!    CALL LBLRTM_File_Inspect(ofile)

    CALL LBLRTM_Layer_Frequency(oFile%Layer(1), frequency)
    print *, size(frequency)
    print *, frequency(1), frequency(size(frequency))

    do i=1,10
        print *, i,  frequency(i), ' -> ', oFile%Layer(1)%Spectrum(i,1)
    end do
    do i=ofile%Layer(1)%n_Points-9,ofile%Layer(1)%n_Points
        print *, i,  frequency(i), ' -> ', oFile%Layer(1)%Spectrum(i,1)
    end do

    ! Now do some calculations:
    n=ofile%Layer(1)%n_Points
    allocate (spectrum(n))
    allocate (transmission(n))
    sum1=0.0d0
    sum2=0.0d0
    do i=1,ofile%Layer(1)%n_Points
        spectrum(i)=oFile%Layer(1)%Spectrum(i,1)
        sum1=sum1+frequency(i)
        sum2=sum2+spectrum(i)
        transmission(i)=exp(-1.0*spectrum(i))
    end do
    do i=n-9,n
        print *, i,  frequency(i), ' -> T -> ' , transmission(i)
    end do

    print * , 'TOTAL ', sum1,sum2

end subroutine ParseFile

