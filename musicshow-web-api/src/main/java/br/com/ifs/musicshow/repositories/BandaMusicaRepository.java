package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.BandaMusicaModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BandaMusicaRepository extends JpaRepository<BandaMusicaModel, Integer> {

    @Modifying
    @Query("UPDATE BandaMusicaModel b SET b.ordem = :ordem WHERE b.id = :id")
    void updateOrdem(@Param("id") Integer id, @Param("ordem") Integer ordem);

    @Query("SELECT COALESCE(MAX(bm.ordem), 0) FROM BandaMusicaModel bm WHERE bm.repertorio.id = :idRepertorio")
    Integer findMaxOrdemByRepertorioId(@Param("idRepertorio") Integer idRepertorio);

    List<BandaMusicaModel> findByRepertorioId(Integer repertorioId);

    boolean existsByBandaIdAndMusicaIdAndRepertorioId(Integer idBanda, Integer idMusica, Integer idRepertorio);
}
