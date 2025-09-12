package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.BandaModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BandaRepository extends JpaRepository<BandaModel, Integer> {

    @Modifying
    @Query("UPDATE BandaModel b SET b.qtdIntegrante = b.qtdIntegrante + 1 WHERE b.id = :idBanda")
    void incrementarQtdIntegrantes(@Param("idBanda") Integer idBanda);

    @Modifying
    @Query("UPDATE BandaModel b SET b.qtdIntegrante = b.qtdIntegrante - 1 WHERE b.id = :idBanda AND b.qtdIntegrante > 0")
    void decrementarQtdIntegrantes(@Param("idBanda") Integer idBanda);

    @Modifying
    @Query("UPDATE BandaModel b SET b.qtdRepertorio = b.qtdRepertorio + 1 WHERE b.id = :idBanda")
    void incrementarQtdRepertorios(@Param("idBanda") Integer idBanda);

    @Modifying
    @Query("UPDATE BandaModel b SET b.qtdRepertorio = b.qtdRepertorio - 1 WHERE b.id = :idBanda AND b.qtdRepertorio > 0")
    void decrementarQtdRepertorios(@Param("idBanda") Integer idBanda);

    boolean existsByNome(String nome);

}
