package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.BandaModel;
import br.com.ifs.musicshow.models.RepertorioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RepertorioRepository extends JpaRepository<RepertorioModel, Integer> {

    @Modifying
    @Query("UPDATE RepertorioModel r SET r.qtdMusica = r.qtdMusica + 1 WHERE r.id = :idRepertorio")
    void incrementarQtdMusicas(@Param("idRepertorio") Integer idRepertorio);

    @Modifying
    @Query("UPDATE RepertorioModel r SET r.qtdMusica = r.qtdMusica - 1 WHERE r.id = :idRepertorio AND r.qtdMusica > 0")
    void decrementarQtdMusicas(@Param("idRepertorio") Integer idRepertorio);

    List<RepertorioModel> findByBanda(BandaModel banda);

}
